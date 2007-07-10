Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXGJNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXGJNyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXGJNyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:54:02 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:22021 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbXGJNyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JIAqBCj+ANIXXE84FXeanfZBeanS5pIm//0x8DrXV/SaWHvWCIdoeC64ILYU/g6qywKkUb00vP0I5lZX+FqU3fSopqdGAWmV5yuCZzYglC6I8N2gDZaF+l9chhthxXj0rJhyQF/z9SRgGZo/P3ykd02ItpPiTTbO+IOkzXQ2dUY=
Message-ID: <48f7fe350707100653w6f01c645u388fbb4691b74c6b@mail.gmail.com>
Date: Tue, 10 Jul 2007 09:53:55 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ACPI: EC: Handler for query 0x80 is not found!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since 2.6.22-rc6-mm1 I have been seeing these messages in dmesg:

ACPI: EC: Handler for query 0x80 is not found!
ACPI: EC: Handler for query 0x81 is not found!

This did not happen in 2.6.22-rc4-mm1. Does anyone have any clue what
this is about?
