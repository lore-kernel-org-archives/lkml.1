Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYKBSzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYKBSzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbYKBSvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:51:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:19263 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbYKBSvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pXHFoPHil1Y4P1SgQY2OM8Aj5JD6XmK4uOZxx3LSBZUqq5QVkHzzPosHdlYRHsBvhC
         Rcal2CBy/1KfFyixwOPribOyh5AanBk+qLr03z5NZTNUFjH/oA44c+T2mK4ngdnreOKY
         KkuKlj7m8ayRszuLMqLLGmrByhXluvjH0UBxk=
Message-ID: <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
Date: Sun, 2 Nov 2008 19:51:15 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll behaviour after running out of descriptors
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
	 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
	 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 7:48 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> Why don't you grep for TIME_WAIT?

Because I don't have access to the test environment at the moment.
