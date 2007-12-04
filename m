Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXLDPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXLDPxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXLDPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:53:36 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:36651 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXLDPxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:53:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:cc:subject:references:from:date:in-reply-to:message-id:user-agent:mime-version:content-type:sender;
        b=mdxp5JMoPgoFaY1r8jIM6ARrd6lK/2Az8XkcSqG1fpZjUoY1zisMAXTgNQJA7RvQLgjnsVLSfdolZ2Txv2Hzwr+UhwCpIgks9il/KK4zNQF2p5O45YA9E0dgnVbZ01dc3CU1EwUwracbHLc81g4T4zDrMFeLc7OvLraXU9N19io=
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/serial/uartlite.c: Add missing of_node_put
References: <Pine.LNX.4.64.0712022105480.3361@ask.diku.dk>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Tue, 04 Dec 2007 16:53:20 +0100
In-Reply-To: <Pine.LNX.4.64.0712022105480.3361@ask.diku.dk> (Julia Lawall's message of "Sun\, 2 Dec 2007 21\:06\:54 +0100 \(CET\)")
Message-ID: <87bq96xxqn.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Julia" == Julia Lawall <julia@diku.dk> writes:

 Julia> From: Julia Lawall <julia@diku.dk>
 Julia> There should be an of_node_put when breaking out of a loop
 Julia> that iterates using for_each_compatible_node.

..

 Julia> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
