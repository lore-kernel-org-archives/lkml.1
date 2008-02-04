Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYBDD3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYBDD3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 22:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYBDD33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 22:29:29 -0500
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:10756 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbYBDD32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 22:29:28 -0500
Date: Mon, 4 Feb 2008 03:22:40 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Basic braille screen reader support
Message-ID: <20080204032240.GF4439@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	torvalds@osdl.org, linux-kernel@vger.kernel.org
References: <20080204031842.GE4439@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204031842.GE4439@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: as said in the comments, this is currently only for the
VisioBraille device, but having this in the vanilla kernel will help a
lot to get people testing drivers for other devices, as they will not
have to recompile a patched kernel but just insert test modules
(remember that for blind people it is already not so easy to just _use_
computers...)

Samuel
