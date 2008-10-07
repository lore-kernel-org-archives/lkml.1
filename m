Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYJGT0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYJGT0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 15:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYJGT02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 15:26:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYJGT02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 15:26:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: [Bug 10797] Battery is drained after poweroff
Date: Tue, 7 Oct 2008 21:30:32 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, rjwysocki@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
References: <48E9F388.8040203@diamondcut.com.br>
In-Reply-To: <48E9F388.8040203@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810072130.33544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 of October 2008, Renato S. Yamane wrote:
> Hi,
> 
> Can someone help us with this bug?
> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> 
> Same problem is reported in Ubuntu:
> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>
> 
> This is not a hardware problem, because if the same laptop is poweroff
> by Windows, battery charge don't change.
> 
> And, if I suspend to ram/disk BEFORE poweroff, battery charge don't
> change (suspend to ram/disk --> WakeUp --> Poweroff).

Have you tried 2.6.27-rc9?

Rafael
