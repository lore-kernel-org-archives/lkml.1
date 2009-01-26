Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZAZWJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZAZWJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZAZWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:09:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:35076 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZAZWJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=iIlwvQ0EHFPR5MkQj9Hb8Mw6oGdfku3qKCL5wHhyh4nHEUPF+LAJBLAjjf5WD7S392
         aKmZaMtWP1rczMYHFf+fen+ENRI64Xckv3PtWzQKkRKoc2H4rDTCVr9jjX/2RhpZpp13
         NIvsvZNeO3ap2lewZ6oR4imnJpa9F2Ijvl35c=
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 14:09:31 -0800
Message-ID: <55fdf7050901261409h67f581f1ib6951ecb60eb8e8@mail.gmail.com>
Subject: cx88 audio input change
From: LINUX NEWBIE <lnxnewbie@gmail.com>
To: mchehab@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

    You've been working on cx88 for a long time.  Can I ask you
something?  I have a cx88 based card and I tried to get audio coming
from "Line In" of my card.  However, it seems like the audio always
comes from TV input.   I looked into the code and it seems like
VIDIOC_S_AUDIO is not working in cx88.  Can you help please?

Thanks.
