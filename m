Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbXD0BPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbXD0BPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbXD0BPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:15:41 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:34222 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbXD0BPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TslUJGGrLdO56qrlesEou8BGn1vdHnFIAH7x2rhzLSTWjZfhoyuuGBj+dUdQ1/3KvGObEK6wcDw44jZ30BBOiUeqpAQLOPhMDavJym65gNcrEJ2n5sxtzjJm9mmPTDUOs7bT0yZeILomGmKNnmuYFxFSzuez/MLyz5JC4M/QG0w=
Message-ID: <2fe399760704261815i428105d4qddc2648688e694bc@mail.gmail.com>
Date: Thu, 26 Apr 2007 18:15:39 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Pin an IRQ to a particular CPU
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In an effort to increase over all throughput of my Linux NFS file
server, I thought about trying to force an IRQ, for the NIC, to be
serviced by a particular CPU.  Is this possible?

TIA,
Phy
