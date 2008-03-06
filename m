Return-Path: <linux-kernel-owner+w=401wt.eu-S1763349AbYCFLqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763349AbYCFLqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYCFLqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:46:00 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:3817 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbYCFLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:45:59 -0500
To: Andrew Haley <aph@redhat.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Michael Matz <matz@suse.de>, Joe Buck <Joe.Buck@synopsys.COM>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
References: <20080305153020.GA24631@volta.aurel32.net>
	<47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>
	<20080305202319.GA17053@volta.aurel32.net>
	<Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	<47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net>
	<47CFBF28.4060309@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Mar 2008 12:45:57 +0100
In-Reply-To: <47CFBF28.4060309@redhat.com>
Message-ID: <871w6ogjnu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2008 11:39:27.0344 (UTC) FILETIME=[BBCCFF00:01C87F7E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Haley <aph@redhat.com> writes:
> 
> I suppose one could apply the precautionary principle, but those systems that
> don't update kernels won't update gcc either, so the solution won't work.

You seem to assume that running a gcc 4.3 compiled binary requires a 
gcc update. That is not necessarily true.

-Andi
