Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYKSSdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYKSSdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYKSScz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:32:55 -0500
Received: from cuda1.bluetone.cz ([212.158.128.5]:46966 "EHLO
	cuda1.bluetone.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYKSScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:32:55 -0500
Message-ID: <49245C1C.2030801@slax.org>
Date: Wed, 19 Nov 2008 19:34:04 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] loop file resizable
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl>
In-Reply-To: <16149.1227066661@jrobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
> Here is the updated one.
> - new function loop_set_capacity().
> - return an error when the backend file is not set.

Thank you very much.
Andrew, would you please consider merging this, it's short and working well.

Thank you.

Tomas M
