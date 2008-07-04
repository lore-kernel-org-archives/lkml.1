Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYGDWtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYGDWtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYGDWtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:49:36 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:48679 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYGDWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:49:36 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, kernel-testers@vger.kernel.org
Subject: Re: 2.6.26-rc8-mm1: unable to mount nfs shares
Date: Sat, 5 Jul 2008 00:49:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807050049.33287.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ mount some/nfs/share
mount.nfs: Input/output error

dmesg says: RPC: transport (0) not supported

but I guess it's known issue http://lkml.org/lkml/2008/7/1/438 ?

	Mariusz
