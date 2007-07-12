Return-Path: <linux-kernel-owner+w=401wt.eu-S935204AbXGLCZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204AbXGLCZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762338AbXGLCZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:25:41 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:10639 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759358AbXGLCZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:25:40 -0400
Message-Id: <469558DB0200005A000275E2@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 11 Jul 2007 22:25:31 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <jim.houston@ccur.com>, <joe.korty@ccur.com>, <dwalker@mvista.com>,
       "David Bahi" <DBahi@novell.com>, "Moiz Kohari" <MKohari@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: !! CORRECTION !! Re: Forward port of latest RT patch
	(2.6.21.5-rt20) to 2.6.22 available
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 00:58 +0000, Gregory Haskins wrote:
> Hi Ingo, Thomas, and the greater linux-rt community,
>   
> 	I just wanted to let you guys know that our team has a port of the
> 21.5-rt20 patch for the 2.6.22 kernel available.  

FYI: Due to an internal mis-communication I thought we had ported up to
rt20, but it is only rt19.  We will merge the rt19-rt20 interdiff and
make a new drop in the next day or so.

Sorry for the confusion! :P

-Greg

