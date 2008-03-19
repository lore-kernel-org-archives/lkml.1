Return-Path: <linux-kernel-owner+w=401wt.eu-S935176AbYCSUtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176AbYCSUtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYCSTqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:46:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:63347 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbYCSTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:46:02 -0400
Message-ID: <7783925d0803181914n16b0a221l179cc350bc2f3f89@mail.gmail.com>
Date: Wed, 19 Mar 2008 07:44:33 +0530
From: "Rick Brown" <rick.brown.3@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: preempt_disable() question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've asked this on kernel newbies before, but not enough responses.

Does preempt_disable() disable preemption on all the processors, or
just the local processor?

TIA,

Rick
