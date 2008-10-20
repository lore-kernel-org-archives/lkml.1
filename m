Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYJTRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYJTRkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYJTRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:40:21 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:42774 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbYJTRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:40:19 -0400
X-Greylist: delayed 2588 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 13:40:19 EDT
Date: Mon, 20 Oct 2008 12:57:09 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc1 and later with intel 915 video
Message-ID: <20081020165709.GO8618@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Dell Latitude D510 laptop, I noticed that starting with 2.6.25-rc1 that
it takes X 2.5 minutes from invoking X to seeing the graphics screen. 
2.6.24 does not have this problem.  The delay also occurs when I switch to
any other VC and again when I switch back.

What can be done to solve the slowness?
