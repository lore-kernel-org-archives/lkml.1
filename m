Return-Path: <linux-kernel-owner+w=401wt.eu-S965781AbXG3RBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965781AbXG3RBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXG3RBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:01:06 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:50405 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965486AbXG3RBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:01:05 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.23-rc1, KVM-AMD problem
Date: Mon, 30 Jul 2007 18:00:55 +0100
User-Agent: KMail/1.9.7
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200707281855.41277.alistair@devzero.co.uk> <200707291510.31731.alistair@devzero.co.uk> <46ADE0DD.1030505@qumranet.com>
In-Reply-To: <46ADE0DD.1030505@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301800.55671.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2007 14:00:13 Avi Kivity wrote:
> How about the attached patch? (I haven't yet tried to reproduce, but
> this can cause an AMD-only oops).

This seems to have fixed the problem. Thanks Avi.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

