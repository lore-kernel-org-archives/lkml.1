Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZKKT6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZKKT6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZKKT6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:58:08 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34600 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZKKT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=G5uAtoCk1NdzHO9raoupvvKUso4OFAv5T/3YWAvDKPk4ltXb1kSYxUg/8wa4Ckq+7h
         p0OX8YqU1ouwTrb+4+e/82FUlZkJPMcQk30PQyi7kzTjX4MKKiq1zld/UTkJHZ39d0O5
         5nGID8kwvtnPWk0pbGKxDD/sP05p9JMUb0MU8=
MIME-Version: 1.0
In-Reply-To: <a44ae5cd0911111141i56c067f2we01cfef857133081@mail.gmail.com>
References: <a44ae5cd0911111141i56c067f2we01cfef857133081@mail.gmail.com>
Date: Wed, 11 Nov 2009 14:58:10 -0500
Message-ID: <a44ae5cd0911111158w4985a6a0n2b30da3421a1b46b@mail.gmail.com>
Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure. 
	order:8, mode:0x8020
From: Miles Lane <miles.lane@gmail.com>
To: Jie Yang <jie.yang@atheros.com>, LKML <linux-kernel@vger.kernel.org>,
       Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is completely reproducible with this kernel.  I get the error on
boot, and then I get it again each time I wake the OS from the suspend
state.

        Miles
