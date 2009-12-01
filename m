Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZLALHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZLALHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZLALHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:07:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:50380 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZLALHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hWUYfv6+24uS/qWXwY8MNUHHh5quG2joai+DC1l7Dhw2i2iTv/Gw3FXrXI7r/h0Q2d
         LMPEVejkEeT2em1MO9uTZWkkMGHxBPYuYEtE076fjEyCvY46NZkvklJtMh1TP5Kq8uj1
         PzAUHf5EUfiH1LbtZw1fKBQ41hCH3uZ7IjMQA=
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 13:07:28 +0200
Message-ID: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com>
Subject: Signal from kernel space to user space
From: Mai Daftedar <mai.daftedar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone
   Im still new to the kernel development world :)and  I was wondering
what functions I can use in the kernel space for a signal to be sent
to the userspace
I tryed a number of examples I found after I did some googling that
used the API "send_sig_info" however nothing worked :(


Any help would be appreciated
Can you please CC me in the reply to this mail
Thanks
Mai
