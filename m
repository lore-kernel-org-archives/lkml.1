Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYA1Ibz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYA1Ibz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYA1Ibr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:31:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:2221 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYA1Ibp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wQnWpxgYZW35MxQLOpjC1sKDU7WVIF0Lly3P2g6xtVUg6Qyi9+8xnrlyVgGF7uH+JN8KWEcXgxKdTLvp6VVlqayHw+upkbuiND24EhZjy6rDtPmln+2YR4J8Bn52zH2VDy/DIi2GcStAaB/VCkTfUH6Mz1KSvCvv6qh6Z1NRun0=
Message-ID: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
Date: Mon, 28 Jan 2008 09:31:43 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all!

in the 2.6.24 become i some soft lockups with usb-phone, when i pluged
in the mobile, then the vfs-layer crashed. am afternoon can i the
.config send, and i bisected the kernel, when i have time.

pictures from crash:
http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/
-- 
Thanks,
Oliver
