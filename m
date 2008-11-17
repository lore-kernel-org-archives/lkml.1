Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYKQQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYKQQlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYKQQlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:41:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYKQQll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:41:41 -0500
Message-ID: <49219DF5.5040404@zytor.com>
Date: Mon, 17 Nov 2008 08:38:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
CC: linux-kernel@vger.kernel.org, tpctl-users@lists.sourceforge.net
Subject: Re: Inclusion of tp_smapi module into kernel?
References: <200811171455.50039.hanno@hboeck.de>
In-Reply-To: <200811171455.50039.hanno@hboeck.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hanno Böck wrote:
> 
> I wanted to ask if there is some status on possible kernel inclusion. On
> http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
> I read
> "will not be accepted upstream due to authorship issues (written by an 
> anonymous developer)"
> 
> Now I can see copyright notices in all source files, though they may be 
> incomplete. But anyway, would this be a real problem?
> Is there any rule that kernel code needs a named author? As long as it has a 
> fitting license, shouldn't this be fine?
> 

We need to be able to identify who owns the copyright.  For all we know,
the anonymous submitter might not have the right to his own work (work
for hire, etc.) or it could have been produced in violation of NDA
terms, etc.

	-hpa
