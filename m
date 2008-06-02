Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYFBUFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYFBUFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYFBUFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:05:11 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:50814 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYFBUFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:05:09 -0400
To: Rick van Rein <rick@groengemak.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Future Linux on Bistable Storage
From: Andi Kleen <andi@firstfloor.org>
References: <20080602125904.GA15129@phantom.vanrein.org>
Date: Mon, 02 Jun 2008 22:04:36 +0200
In-Reply-To: <20080602125904.GA15129@phantom.vanrein.org> (Rick van Rein's message of "Mon, 2 Jun 2008 12:59:04 +0000")
Message-ID: <87prqzvc17.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jun 2008 19:57:29.0254 (UTC) FILETIME=[E3289C60:01C8C4EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick van Rein <rick@groengemak.nl> writes:

> Some degree of serialism must exist, but after scanning a bus would
> it not be possible to fork threads to initiate each of the devices found
> on it?

Multithreaded driver initialization has been tried, but reverted
because it triggered too many driver bugs.

-Andi

