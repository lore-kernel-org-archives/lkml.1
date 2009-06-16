Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZFPCrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZFPCrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZFPCqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:46:55 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:42854 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZFPCqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KZImleUesXcDm8fX6CDCNThyuKl9ZzBVWPJGKbFB31CqqoAYlD76Pub1YNOOF9Y4jN
         HEcp719P3DbzgkWOzpIM3b2z/9m2wpdbFBmAOy4km7muQDOA52/mexAjI+WH7npdZ3YR
         i89K/eeRE+gyZHjw7XvyEbbsXsh0/qGPNxvRs=
Subject: Re: [PATCH] libcap: Change address of the libcap source.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew G.Morgan" <morgan@kernel.org>,
       Alexander Kjeldaas <astor@guardian.no>
In-Reply-To: <1245119521.20635.105.camel@centos51>
References: <1245119521.20635.105.camel@centos51>
Content-Type: text/plain; charset=euckr
Organization: Private
Date: Tue, 16 Jun 2009 11:46:50 +0900
Message-Id: <1245120410.20635.113.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009-06-16 (화), 11:32 +0900, GeunSik Lim 쓰시길:
> 
> Dear Jiri Kosina.
> 
> This is patch to change ftp site of the libcap source. 
> Merge this patch. 


Um.. It's strange. 
It seems that "astor@guardian.no" email is not exist. 
I received  "Delivery status notification (Failuer)" message like belows. 

----- Original Message ----- 
From: "Mail Delivery Subsystem" <mailer-daemon@googlemail.com>
To: <leemgs1@gmail.com>
Sent: Tuesday, June 16, 2009 11:32 AM
Subject: Delivery Status Notification (Failure)

> This is an automatically generated Delivery Status Notification
> Delivery to the following recipient failed permanently:
> 
>     astor@guardian.no
> 
> Technical details of permanent failure: 
> Google tried to deliver your message, but it was rejected by the 
> recipient domain. We recommend contacting the other email provider 
> for further information about the cause of this error. The error that 
> the other server returned was: 550 550 5.3.0 relay not permitted (state 14). 


For refernece, 
I found  astor@guardian.no e-mail address in compability.h file. 

[invain@centos51 linux]# head -n 6 capability.h 
/*
 * This is <linux/capability.h>
 *
 * Andrew G. Morgan <morgan@kernel.org>
 * Alexander Kjeldaas <astor@guardian.no>
 * with help from Aleph1, Roland Buresund and Andrew Main.
[invain@centos51 linux]# 


Thks,


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

