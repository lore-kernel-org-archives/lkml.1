Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYDPUwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYDPUwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYDPUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:51:53 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:24347 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYDPUvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:51:53 -0400
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
From: Andi Kleen <andi@firstfloor.org>
References: <20080416202338.GA6007@elte.hu>
Date: Wed, 16 Apr 2008 22:50:51 +0200
In-Reply-To: <20080416202338.GA6007@elte.hu> (Ingo Molnar's message of "Wed, 16 Apr 2008 22:23:38 +0200")
Message-ID: <878wzdikwk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Apr 2008 20:44:05.0313 (UTC) FILETIME=[9C531B10:01C8A002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>  - generalized bitops - they are faster and smaller.

Faster in a 100% bogus benchmark with the most unrealistic input data
set one can imagine with some effort. They might be faster or they
might be slower, nobody really knows currently.

-Andi
