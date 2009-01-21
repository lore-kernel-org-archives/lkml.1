Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZAUK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZAUK2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763552AbZAUK2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:28:04 -0500
Received: from fxip-0059e.externet.hu ([88.209.247.158]:35205 "EHLO
	teledigit.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763513AbZAUK2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:28:01 -0500
X-AuthUser: kgy@teledigit.hu
From: =?utf-8?q?K=C3=B6vesdi_Gy=C3=B6rgy?= <kgy@teledigit.hu>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 11:25:46 +0100
User-Agent: KMail/1.9.9
References: <200901211029.01619.kgy@teledigit.hu> <4976F0EB.8050806@trash.net>
In-Reply-To: <4976F0EB.8050806@trash.net>
Cc: Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211125.46866.kgy@teledigit.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for the report. Does this patch fix it?
Thanks, it works!

Regards
K. Gy.
