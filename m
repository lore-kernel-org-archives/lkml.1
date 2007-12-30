Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbXL3AgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbXL3AgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 19:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXL3AgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 19:36:10 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:21584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbXL3AgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 19:36:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=swO3gHQdtnmTY8DdTeqrlyYfrAKgbDb00qUeC+gtk2A5WL91yBYt5ktDvJo0oATH3QdZWek98g8Enc81pBZXWyVN+FJgf4Gii+X1hLJKIEWozgbPAnTDqR86WW4W7P909fkebF1KSo4h/doLovAxx1Ekb+xUlsU/Z+j2VFzf2rU=
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: "David P. Reed" <dpreed@reed.com>
Cc: Richard Harman <richard@richardharman.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
In-Reply-To: <1198967334.5049.3.camel@iamer-laptop>
References: <47765D11.2040903@reed.com>
	 <1198967334.5049.3.camel@iamer-laptop>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 02:35:25 +0200
Message-Id: <1198974925.7055.0.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, pressed send too soon. here is the line in dmesg:

Compaq Presario v6000: using alternate I/O delay port


Thanks, please tell me if you need anymore info.

