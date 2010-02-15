Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265Ab0BOTlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:41:24 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49936 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab0BOTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qcnwVNynhkaLEVqounOva4JZOOzA6AG+JbG4BPN8NPUbTZQ/kJDa5hZXaIgtIZkJpW
         UDp8CHYlP9i2OKYJQnhejTDM/uJ7crjbKNo2p3A9+m/umynQKLSu7OWvyW7O1CVkz1TW
         5giu829xOdPk6A4x6bjOzM+YFuLM7o3yN/qRc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: John Kacur <jkacur@redhat.com>
Subject: Re: [BUG]: Possibe recursive locking detected in sysfs
Date: Mon, 15 Feb 2010 20:41:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
In-Reply-To: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152041.18800.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 11 lutego 2010 o 18:11:46 John Kacur wrote:
> I'm not sure if this one has already been reported. - thanks.
> 
> Feb 11 07:24:15 localhost kernel: [ INFO: possible recursive locking
>  detected ] Feb 11 07:24:15 localhost kernel: 2.6.33-rc7 #1
[...]

I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15319
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
