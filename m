Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZHYRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZHYRkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZHYRkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:40:18 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63101 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZHYRkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tn5Uq4wUXP7JmTT/IGmz87Qtl5urlyOZ+kUNmFfRYavNGjYs9/bZrWnIdTfIIVw+wC
         dXMnpfvbxejEvmiGcxmuYaqlp5LQsJbFw25sTW0zW7/qygK/v+s3tdz8rUxHt4e34c5O
         q+xUb8Y/rPhFVUPFMjLzQ46SsxUI8+jJiz+XA=
Message-ID: <4A9421F5.1090100@gmail.com>
Date: Tue, 25 Aug 2009 19:40:05 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc/rbtree: fix inserting example
References: <4A918BAF.8020600@gmail.com> <20090824124239.f7525b97.randy.dunlap@oracle.com>
In-Reply-To: <20090824124239.f7525b97.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 23 Aug 2009 20:34:23 +0200 Marcin Slusarz wrote:
> 
>> rb_link_node and rb_insert_color take pointer to struct rb_node
>> as a first parameter, but example code passes plain struct rb_node.
>> Fix it.
> 
> This is already corrected in the mainline kernel tree, right?

yes, sorry for bothering

Marcin
