Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0BGNXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:23:31 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:60951 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0BGNX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LM7rIMF6+EZ9AKiM06kM1YX2LG+1ClvGJ50tdrZRgiNmKQxRGyBmav7QHWuSsDmsJQ
         NHeD1CCN3P3fsQBcjSN55Zi0r3BGxRCC+HvvZA6O8QYGcHvH5PxmXpYYjGHMsEjhMYmq
         ABCN0RVgFVboyRS96GLdCUj4qCrYjTaRA89FI=
Date: Sun, 7 Feb 2010 15:23:31 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: Bad page state in process portageq
Message-ID: <20100207132331.GA4138@x200>
References: <201002070145.47514.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002070145.47514.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 01:45:46AM +0100, Johannes Hirte wrote:
> Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process portageq pfn:2846d

Run memtest.
