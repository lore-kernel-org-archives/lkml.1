Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZGIGDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZGIGDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZGIGDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:03:03 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:60501 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZGIGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RxsG1k7s/ruj/g6mHQXzXPZNGWPOUBIPqz2sj1S3AIFwzlZOoJjxHo4jD0Htefs6uu
         IB1iTi1W0M74d1T89hF8ZAnA+6GV5ttHum1rOxc14rXymA4uJYZXqBrc0oU7JKw63aKz
         Xx+0h10CEVoXeK7A6l71EyYw37O1qvQsvwyR8=
Date: Wed, 8 Jul 2009 23:02:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] pcspkr: switch driver to dev_pm_ops
Message-ID: <20090709060256.GC14516@dtor-d630.eng.vmware.com>
References: <200907081418.37229.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907081418.37229.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:18:36PM +0200, Frans Pop wrote:
> Gets rid of the following warning:
> Platform driver 'pcspkr' needs updating - please use dev_pm_ops
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Applied, thanks Frans.

-- 
Dmitry
