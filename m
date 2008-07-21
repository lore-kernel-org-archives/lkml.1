Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYGUOYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYGUOYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYGUOX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:23:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYGUOXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:23:55 -0400
Date: Mon, 21 Jul 2008 16:23:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Please pull ACPI tree
Message-ID: <20080721142343.GA11345@elte.hu>
References: <20080721114321.GA28786@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721114321.GA28786@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> This reverts some double commits and a trouble some FADT patch.

> Andi Kleen (4):
>       Revert "dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled."

in that commit log you say:

   Revert "dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled."
   Revert double commit by mistake. Noticed by Thomas Gleixner.

it wasnt just "noticed" by Thomas, he sent a reverter patch with commit 
message and patch included. Why didnt you simply apply the patch from 
Thomas?

	Ingo
