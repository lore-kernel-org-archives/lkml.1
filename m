Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZGPH1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZGPH1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZGPH1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:27:13 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:60631 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZGPH1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:27:12 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.4.rc1
References: <7vmy75bg2f.fsf@alter.siamese.dyndns.org>
 <4A5EA598.5050801@garzik.org> <7v3a8xb0lz.fsf@alter.siamese.dyndns.org>
 <4A5ECC09.3010405@garzik.org> <7vocrl9kwi.fsf@alter.siamese.dyndns.org>
 <4A5ED38F.5070708@garzik.org>
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 16 Jul 2009 00:27:03 -0700
In-Reply-To: <4A5ED38F.5070708@garzik.org> (Jeff Garzik's message of "Thu\,
 16 Jul 2009 03\:15\:27 -0400")
Message-ID: <7v4otd9jg8.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 144E07A6-71DA-11DE-B90E-9AE02FB70C38-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> That direction doesn't work due to firewalls, hence the scp out /to/
> remote.example.com.

Ah, then the "git init --bare" at remote followed by pushing -all into it,
suggested in your other subthread, would be an appropriate way.
