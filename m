Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbYHTJr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbYHTJr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYHTJrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:47:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYHTJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:47:23 -0400
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
From: Andi Kleen <andi@firstfloor.org>
References: <200808200245.AA00210@capsicum.lab.ntt.co.jp>
Date: Wed, 20 Aug 2008 11:47:18 +0200
In-Reply-To: <200808200245.AA00210@capsicum.lab.ntt.co.jp> (Ryusuke Konishi's message of "Wed, 20 Aug 2008 11:45:05 +0900")
Message-ID: <87iqtwyq55.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:

> It has many TODO items:

How stable is the on-disk format? If the file system makes mainline
your user base would likely increase significantly. Users then tend
to have a reasonable exception that they can still mount old file systems
later on newer kernels (although not necessarily the other way round)

-Andi
