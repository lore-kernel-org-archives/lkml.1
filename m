Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYKCKOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYKCKOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYKCKOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:14:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:62842 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYKCKOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding:sender;
        b=Kt3dRaEUekwvmSy85jVUq9LSiJ7IvfEdLsm/jsd7XNcLHg/yQa8COtPgL/t5LW3Quq
         X+JmOtXkfzorOC/2dK+uRsbqzHcSmqhdmMAIsG8Wfk4Iv7VCteebut/nfpsHfKK2sGOa
         Y3PJSVTIJCT1ML5R9C5EpB9MSZCPZKKnKcQgg=
Message-ID: <490ECEFD.8000409@gmail.com>
Date: Mon, 03 Nov 2008 11:14:21 +0100
From: Giovanni Pellerano <giovanni.pellerano@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11664] acpi errors and random freeze on sony vaio sr
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera> <4xS1r6m15_B.A.xNB.iveDJB@chimera> <490DF64C.1090104@gmail.com>
In-Reply-To: <490DF64C.1090104@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a random factor i also get this:

ACPI Error (evevent-0303): No installed handler for fixed event
[00000002] [20080926]



and the acpi stop handling all events, like powerbutton and other;

any assumptions?
