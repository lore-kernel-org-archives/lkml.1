Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXKYCwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXKYCwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 21:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXKYCwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 21:52:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:23324 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXKYCwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 21:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oQRl1jB/rnQY/ykb4MTQhjZdiQJ66PX2/+I1D6eCtqn4VHy5ayZ2uhWEeK3yf3BVtNIuXOWScozPt6mHn5S/jsC2w8d/8gfpJ3Ygc5bsZd1xnNnmT/uI9iCcCz9ELJYQpa+NaaTikVWH4ulKbrfLBV5R4D9EDX6ZPN2AjN7Azqk=
Message-ID: <c22ebab10711241852v687b384fpd638ff565756232a@mail.gmail.com>
Date: Sun, 25 Nov 2007 03:52:33 +0100
From: Jeroen <j.geusebroek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: forcedeth ethernet driver & Low power state
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm migrating my server from windows 2003 server to Ubuntu, but I am
stumbling over the "Low Power State Link Speed" option for my NIC
(forcedeth)

I need to disable this option in my windows driver otherwise the trough pout is
horrible because the link fluctuates constantly from 100/1000.

Anyway, my question is where and how can I turn off this feature for the
forcedeth driver? I've looked in the source and as far as I can tell there is no
bootoption for this. There are some references noted in the code, but AFAIK
no setting.

Any ideas? Thanks in advance!

-- 
Jeroen
