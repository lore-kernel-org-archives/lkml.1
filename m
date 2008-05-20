Return-Path: <linux-kernel-owner+w=401wt.eu-S934579AbYETPcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579AbYETPcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbYETPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:29 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35658 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189AbYETPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:27 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080520528.793382059@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/11] REPOST: Early exception fixes
Date: Tue, 20 May 2008 17:28:41 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:40.0839 (UTC) FILETIME=[342A1F70:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly saves some code size and cleans up the code after Roland's 
recent changes.

Please ack or nack.

-Andi
