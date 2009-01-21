Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZAUFRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZAUFRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZAUFR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:17:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54680 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZAUFR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:17:26 -0500
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hannes@saeurebad.de
Subject: Re: emacs indenting howto
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.2.00.0901191521270.2904@bikeee>
Date: Wed, 21 Jan 2009 06:16:31 +0100
In-Reply-To: <alpine.DEB.2.00.0901191521270.2904@bikeee> (Dan Carpenter's message of "Mon, 19 Jan 2009 15:56:21 +0300 (EAT)")
Message-ID: <87fxjddys0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> I don't think emacs understands tilda expansion.  It didn't work for me.

It does when you use expand-file-name

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
