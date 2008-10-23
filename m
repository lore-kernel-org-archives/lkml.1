Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYJWMDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYJWMDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYJWMDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:03:34 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:30346 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYJWMDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y3+Gog8dJxaf3LiVZLFiMzozYjXAGyKsppn4lLqpSjkMRj5P5/6mUIl4Ty9HcC+dn5
         E3NnzbG9+D1yzLvPQPk72hajjNNfgpBfQXgBk+l+5h6AlaYa2Jmw+ChVvBoXDs4H/EKw
         999azUIMSnkZWKPPC7NhTYgPgzJYGuSim5dP8=
Date: Thu, 23 Oct 2008 16:06:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David John <davidjonx@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How do I printk <type> correctly?
Message-ID: <20081023120251.GA27984@x200.localdomain>
References: <20081023114133.GA30187@x200.localdomain> <49006553.4020401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49006553.4020401@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 05:21:47PM +0530, David John wrote:
> Useful list, but I think there are more format specifiers available with
> printk though.

This list for not generating compile-time warnings, nothing more.
