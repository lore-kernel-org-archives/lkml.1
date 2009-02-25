Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZBYAMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZBYAMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBYAMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:12:44 -0500
Received: from kuber.nabble.com ([216.139.236.158]:43162 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZBYAMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:12:43 -0500
Message-ID: <22193693.post@talk.nabble.com>
Date: Tue, 24 Feb 2009 16:12:41 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: page_address not working
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am using the function page_address to get the virtual address of a page
using its pointer. I am using kernel 2.6.24 and page_address has been
exported. However, when I make a call to page_address in my kernel module,
it does not allow me to use it, saying, "Implict declaration of
page_address".

Is there any other way, I can get the virtual address of a page from a
pointer to its structure

Thanks
SC
-- 
View this message in context: http://www.nabble.com/page_address-not-working-tp22193693p22193693.html
Sent from the linux-kernel mailing list archive at Nabble.com.

