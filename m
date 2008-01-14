Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbYANM4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbYANM4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 07:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYANM4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 07:56:43 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:49495 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYANM4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 07:56:42 -0500
Date: Mon, 14 Jan 2008 13:56:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080114125638.GA9510@basil.nowhere.org>
References: <20080114094814.GA28300@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114094814.GA28300@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Jan 2008 12:50:28.0198 (UTC) FILETIME=[09FCB860:01C856AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject was wrong of course -- it was a recursive oops, not a double fault.
Sorry for the inaccuracy.

Hopefully it can be fixed soon because it inhibits further testing here.

-Andi
