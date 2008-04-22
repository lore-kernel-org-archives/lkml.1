Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYDVQxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYDVQxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYDVQxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:53:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:41854 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbYDVQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s0xnJvwOW4Ja0zu7wGa/cG1TCi5HMZGFOX18YcsUpp5CFgdGMy63VFAm/7VgA1w4GzBmiX91pERzJuLZJU3F/tXX0qeesVkDZ9FpxXxQaEDP0FE2P9fcKbBfmAGedhOxHns8vteT3jNBKMqkfxGtZV1sVWKtPcM8oPLiLZuvx/s=
Message-ID: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
Date: Tue, 22 Apr 2008 22:23:21 +0530
From: "Sanjeev Aditya Naga" <sanjeev.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: config file part of kernel!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Will it be good, if we make the `config` file (used to
build a kernel) part of the built kernel. So that one in
need, can extract it from the kernel using some
userspace tool!?

During the configuration of kernel, we usually set
the required functionality. However, if we delete the
sources/config file or loose the config file, but later
we wanted to add up some module(s) to the same
kernel, it'd be great if we will be able to extract some
info from the kernel along with the config params!??

Regards,
Sanjeev
