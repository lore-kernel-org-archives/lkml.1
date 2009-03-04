Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZCDOOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZCDOOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZCDONw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:13:52 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:32018 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbZCDONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:13:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NADixnn6Bw6voGSHD024HxQHow4eW9Lsw758KNUUCH4EM9s3rNU7OaMb0stq/tN7eu
         6k5p9q//ZDUuSlocUSBcOwwrfygCmiI5+cpAAeBpVT4qm0W+3IM5q2saV3WKrNFaOpxG
         /PSk4MLSoSCWk1o8wgjFxwAGzWplTAjJVZsBk=
Date: Wed, 4 Mar 2009 23:13:44 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] generic debug pagealloc
Message-ID: <20090304141343.GB7168@localhost.localdomain>
References: <20090303160103.GB5812@localhost.localdomain> <49AD56F3.6020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <49AD56F3.6020305@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 05:12:35PM +0100, Jiri Slaby wrote:
> Just an optimisation: pass the i to the dump_broken_mem as a start index.

OK. I'll remove that redundancy in next verserion.
