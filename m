Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbZJ3SS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbZJ3SS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932828AbZJ3SS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:18:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbZJ3SS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:18:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: 2.6.31.4 panic: CRED: put_cred_rcu() sees ffff880204e58c00 with usage 82150912
Date: Fri, 30 Oct 2009 19:20:56 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
       nikola.ciprich@linuxbox.cz, KVM list <kvm@vger.kernel.org>
References: <20091030110632.GC6416@develbox.linuxbox.cz> <20091030111534.GD6416@develbox.linuxbox.cz>
In-Reply-To: <20091030111534.GD6416@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910301920.56662.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 October 2009, Nikola Ciprich wrote:
> Ouch, typo in subject, it's 2.6.31.1 of course. sorry about that.
> also CCing kvm.

What about later kernels?  Mainline in particular?

Rafael
