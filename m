Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411Ab0AMVJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0AMVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400Ab0AMVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:09:25 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:35112 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab0AMVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:09:23 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: question on atomic_t
Date: Wed, 13 Jan 2010 22:10:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001132210.12277.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is the behavior of atomic_t on overflow defined on all architectures?

	Regards
		Oliver
