Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYE3VrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYE3VrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYE3Vqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:46:52 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54542 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYE3Vqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:46:51 -0400
Date: Fri, 30 May 2008 22:35:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Clifford Wolf <clifford@clifford.at>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add rlimits to /proc/<PID>/status
In-Reply-To: <20080530201104.GG1369@clifford.at>
Message-ID: <Pine.LNX.4.64.0805302232430.31527@blonde.site>
References: <20080530201104.GG1369@clifford.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aren't they better staying in /proc/<PID>/limits?

Hugh
