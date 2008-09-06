Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYIFJfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYIFJfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 05:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIFJfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 05:35:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:45969 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYIFJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 05:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sIu5whhVFRak+kssSLFhPQDFqIkTXw3QZY3IQSU9wzaW9T1Qm5iHsE56ANvdzv8RVS
         gywoa1jSMzm4FS8qU74L2OEMQR6xYFCchgThS3hzvQZF82JvmuJAVNAy6AQnr6EKo90X
         ZnaSdP5Z9m6QdC2ADC/Z1e1C+FZvYM+qDy59o=
Message-ID: <5d96567b0809060235w266d0bd9l98bb40163c4af2f7@mail.gmail.com>
Date: Sat, 6 Sep 2008 11:35:08 +0200
From: Raz <raziebe@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: SOS new timer:
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a new timer implementation based on SOS. resolution of microseconds or 100ns.
first draft, still needs many fixes.

http://sos-linux.cvs.sourceforge.net/sos-linux/sos/

-- 
Raz
