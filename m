Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbZAKGNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbZAKGNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZAKGNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:13:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZAKGNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:13:37 -0500
Message-ID: <49698DFC.4040505@zytor.com>
Date: Sat, 10 Jan 2009 22:13:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: joseluismarchetti@yahoo.com.br, linux-kernel@vger.kernel.org
Subject: Re: How to access a regular file from within a module ?
References: <888012.80064.qm@web34402.mail.mud.yahoo.com> <1231652146.4235.6.camel@perihelion.bos.jonmasters.org>
In-Reply-To: <1231652146.4235.6.camel@perihelion.bos.jonmasters.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> 
> [NOTE: If you're doing embedded development and you don't have an EEPROM
> on your board, and you're asking this because someone told you to find
> the cheapest and nastiest solution in software, then look at passing in
> the desired MAC via the firmware, as many embedded boards already do. ]
> 

Or just have the startup scripts set it via ifconfig.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

