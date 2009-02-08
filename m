Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZBHJoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZBHJoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZBHJoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:44:07 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:41472 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZBHJoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:44:05 -0500
From: Junio C Hamano <gitster@pobox.com>
To: Matthieu Moy <Matthieu.Moy@imag.fr>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.6.2-rc0
References: <7vvdrlsyjm.fsf@gitster.siamese.dyndns.org>
 <vpqprhte3rs.fsf@bauges.imag.fr>
Date: Sun, 08 Feb 2009 01:43:58 -0800
In-Reply-To: <vpqprhte3rs.fsf@bauges.imag.fr> (Matthieu Moy's message of
 "Sun, 08 Feb 2009 09:23:03 +0100")
Message-ID: <7vvdrlz2jl.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 06295874-F5C5-11DD-AE29-8B21C92D7133-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu Moy <Matthieu.Moy@imag.fr> writes:

> Junio C Hamano <gitster@pobox.com> writes:
>
>> GIT v1.6.2 Release Notes (draft)
>> ================================
>>
>> With the next major release, "git push" into a branch that is
>> currently checked out will be refused by default.  You can choose
>> what should happen upon such a push by setting the configuration
>> variable receive.denyCurrentBranch in the receiving repository.
>
> Perhaps this paragraph should tell _why_ this is a dangerous
> operation.

I considered it, but that is not what Release Notes is about.  It should
be a table-of-contents of the highlights in the new release.  Interested
parties can look at the documentation for gory details.
