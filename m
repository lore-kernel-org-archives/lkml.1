Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYDCKqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYDCKqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYDCKqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:46:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43507 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYDCKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:46:31 -0400
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
In-Reply-To: <47F44D25.6030001@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
	 <20080401065534.a6267b96.pj@sgi.com>	<47F34625.6000600@jp.fujitsu.com>
	 <20080402061405.197c0c90.pj@sgi.com>  <47F44D25.6030001@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 12:46:16 +0200
Message-Id: <1207219576.8514.823.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 12:21 +0900, Hidetoshi Seto wrote:

> I believe there are quite technical reasons why we have no "idle_map."
> Excellent answers would be brought by scheduler folks...

Can you say: 'cacheline bouncing fest'? :-)



