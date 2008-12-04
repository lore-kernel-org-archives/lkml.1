Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYLDPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYLDPoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYLDPmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:42:38 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:62720 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736AbYLDPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:42:37 -0500
Date: Thu, 4 Dec 2008 16:42:31 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [W1] Added touch block command.
Message-ID: <20081204154231.GC4864@gambetta>
References: <12284022104086-git-send-email-zbr@ioremap.net> <122840221468-git-send-email-zbr@ioremap.net> <12284022143564-git-send-email-zbr@ioremap.net> <12284022144105-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12284022144105-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 05:50:07PM +0300, Evgeniy Polyakov wrote:
> -			cn->ack++
> +			cn->ack++;
Which we find here, sorry for the noise :-)
