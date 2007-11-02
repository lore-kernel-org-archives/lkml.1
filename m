Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbXKBOGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbXKBOGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbXKBOGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:06:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXKBOGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:06:21 -0400
Message-ID: <472B2EBD.7070007@redhat.com>
Date: Fri, 02 Nov 2007 07:05:49 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org>
In-Reply-To: <472ADC78.6070706@openvz.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Emelyanov wrote:
>> Isn't it this?
>>
>> http://lkml.org/lkml/2007/11/1/141
> 
> That was the initial problem, and I already answered to Ingo about
> it

No, look at my old mail which Ingo referenced in that posting.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHKy692ijCOnn/RHQRAtYLAJ98EXTGl3HMlCbVXOkL7TJRFfw4DACfcgYI
HHz5f7TfM05Dps+ruPRiUrU=
=IjS4
-----END PGP SIGNATURE-----
