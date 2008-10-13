Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbYJMM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbYJMM2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYJMM2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:28:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49838 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbYJMM2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:28:11 -0400
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
From: Andi Kleen <andi@firstfloor.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
Date: Mon, 13 Oct 2008 14:28:06 +0200
In-Reply-To: <1223895506638@dmwebmail.dmwebmail.chezphil.org> (Phil Endecott's message of "Mon, 13 Oct 2008 11:58:26 +0100")
Message-ID: <87zll8r86h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:

> Am I right in thinking that CONFIG_MCORE2 is the correct choice for an
> Intel Atom? 

No, Atom is completely different from a Core2.

Right now 586 or 686 is a reasonable choice.

-Andi
