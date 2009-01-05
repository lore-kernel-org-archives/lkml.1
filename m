Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbZAEXgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbZAEXgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZAEXgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:36:14 -0500
Received: from mail-gx0-f27.google.com ([209.85.217.27]:41917 "EHLO
	mail-gx0-f27.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZAEXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=T6jnhCRMlYl1x4wJ0aRVYvfHJvBiRxT81QMhPiRSc1xcUwN0lPfBSwWP9hqMxa1V2D
         ytxCeMual8sgO8uuIrs7oAGvZnvF+g+3KQnQ4Xnn2AgngUO5xpIxpcpaHCrfSfncc2WP
         MoMf/WgDpnsjG4cwKF7E4/+QOq4AlXlVdIjWM=
Message-ID: <ed82fe3e0901051536n5858d823r4c2a7f8eaa74ca4e@mail.gmail.com>
Date: Mon, 5 Jan 2009 17:36:11 -0600
From: "Timur Tabi" <timur@freescale.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Can kernel-doc process simple macros?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 9f95f13d8d978708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can I get kernel-doc to document a line like this:

#define MY_CONSTANT 10

The documentation doesn't say anything about macros, but Google
searches imply that there is some support for macros in kernel-doc.

-- 
Timur Tabi
Linux kernel developer at Freescale
