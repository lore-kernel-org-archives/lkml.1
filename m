Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0BPAHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:07:52 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54934 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0BPAHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=D6urVXAsJgyfJufVl5lLPMj6iQqcVJunSI+mmVoIeAezjYQM79bU5GR+0fYpI2xwt6
         dCs2a8HWSAnrend+kYmyz05ltefGORleYXV0kvhLJTTQilmxlPaC1flLwYFEzsye1LLn
         uPs0tE+XAktMf5d70gn/sV652HDH46tQM25+M=
MIME-Version: 1.0
Date: Tue, 16 Feb 2010 02:07:49 +0200
Message-ID: <912ec82a1002151607q5fae8c4xb12e12b53a85b773@mail.gmail.com>
Subject: dmac_*_range vs. outer_*_range ?
From: Neshama Parhoti <pneshama@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the difference between those 2 set of functions ?

reminder:

dmac_inv_range vs. outer_inv_range;
dmac_clean_range vs. outer_clean_range;
dmac_flush_range vs. outer_flush_range;

thank you in advance!
