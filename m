Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbXLDTUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbXLDTUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXLDTUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:20:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:14480 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXLDTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:20:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=F+WW52GFkWvlCN9R38tpfi6Q7lqZgQiVsj1e5t+zpQwrX8azmmSA3ZqzVgqzMBMo58se5pxcSodkInEdpP7yK+jAV9CYkVAG9I2RxCEuHvbOY4u8FwT0oXt2w6BozlrzVWc6kC16bl7l+HipI6hqGSkn9XmDX2cCXSkcSUP9gPY=
Date: Tue, 4 Dec 2007 20:19:33 +0100
To: linux-main <linux-kernel@vger.kernel.org>
Subject: Best way to detect CF id strings
Message-Id: <20071204201933.50d64f52.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Usually I detect them by attaching CF->PCMCIA adapter to my laptop, but would much rather be able to use my usb-CF adapter.
This would also alot easier to explain to users which are having issues (unsupported/unknown id's).

Any good suggestions on this?

Best wishes
Kristoffer
