Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254Ab0APU3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0APU3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 15:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016Ab0APU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 15:29:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48514 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0APU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 15:29:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tvwodcXxv76RetLmjzBZgpT2U0l/OKzV7zQwFkovAakJfC7kxwZydkb7ogFnZ/Wbrv
         diKEl8uNddGRrsdiwmLot8nz+x7yqAYFeqU/82NoNpYmf/Cn6I+qYqlwS3Zd8gqdqh7I
         kHygMsyAPbdQ98tYQK71j7g949ZVS0A+BnPWM=
MIME-Version: 1.0
In-Reply-To: <20100116195822.GB31079@in.ibm.com>
References: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
	 <20100116195822.GB31079@in.ibm.com>
Date: Sat, 16 Jan 2010 21:29:42 +0100
X-Google-Sender-Auth: 17c34a4142a72c90
Message-ID: <ff13bc9a1001161229t3a4348b5gabbb593d2a962148@mail.gmail.com>
Subject: Re: [PATCH] Fix broken mmiotrace due to dr6 by reference change
From: Luca Barbieri <luca@luca-barbieri.com>
To: prasad@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems kgdb needs to be fixed too.
