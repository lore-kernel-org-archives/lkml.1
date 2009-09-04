Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZIDR6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZIDR6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZIDR6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:58:04 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60347 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbZIDR6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HDzVma6/2jlo1zxM9llRm5S8OR3fz/8JQLyqNN1ptpdHr1i7SNYVpqPuNuFt0PdgWf
         9SvkH4onPYY+gzg/nT46mvCSVyY7sGO96K/bFe+d2yAvYxR1BubySumQ363/qHEbLS89
         bIwu8cGEFs2+JVAXg8tEM78YlhBZvLSMj4ti4=
MIME-Version: 1.0
In-Reply-To: <9a518b600906150207l1be4c0e4w6e2ec2ece6b89181@mail.gmail.com>
References: <9a518b600906150207l1be4c0e4w6e2ec2ece6b89181@mail.gmail.com>
Date: Fri, 4 Sep 2009 19:58:03 +0200
Message-ID: <9a518b600909041058k409863l3eebb05d97a0df6e@mail.gmail.com>
Subject: Re: [PATCH] force key-release events for Samsung p560 and r560 
	laptops in atkbd.c
From: Gordon <gkoefner@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
in my previous message I said "do not produce "unknown key pressed"
events in dmesg.", although that would be great, they do. Sorry about
the error.

Also: nobody has replied to that message as of yet, and it has not
been included into the kernel. The patch is probably outdated now, but
it is basically the same thing as with the NC10 and NC20.

best regards,
Gordon Köfner
