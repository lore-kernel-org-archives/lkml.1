Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYCLKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYCLKdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYCLKdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:33:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48612 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYCLKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:33:13 -0400
Date: Wed, 12 Mar 2008 10:33:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zbynek Drlik <drlik.zbynek@opentech.sk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel oops
Message-ID: <20080312103312.GH27894@ZenIV.linux.org.uk>
References: <e8eb01770803120245x7690e6a9te8ad04296aa3fc4d@mail.gmail.com> <e8eb01770803120249te7453f6r61fc6c5d916446d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8eb01770803120249te7453f6r61fc6c5d916446d6@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:49:03AM +0100, Zbynek Drlik wrote:
> Hello. This is my problem after I upgraded to 2.6.24-r3. I am not to
> be able run ldconfig (segmentation fault).

Could you bisect that?
