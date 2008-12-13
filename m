Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYLMK2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYLMK2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 05:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYLMK1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 05:27:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:23448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbYLMK1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 05:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Zr8ttc8WjKPii1pER5G2Q1JdpBBl69guUiOn0QN0o4MoKfM/J53JihpNdxrWxtIfRV
         qstTSTtVSeigF+QaXFPhw4827jMbqhusL3vTBX9RwxkxeDfqaTj2zbJrgXGngV05OpoJ
         0a+VL1C6ycTLv5v/10KlJay6lD8tF5cB8ieo0=
Message-ID: <e2e108260812130227t15f9cca9v6e7f74e7bee5fa72@mail.gmail.com>
Date: Sat, 13 Dec 2008 11:27:49 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][RFC 21/23]: iSCSI target driver
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1229163388.4153.867.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494009D7.4020602@vlnb.net> <49401205.8010207@vlnb.net>
	 <1229036109.4153.585.camel@haakon2.linux-iscsi.org>
	 <4942BADE.5010907@vlnb.net>
	 <1229162586.4153.851.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130211m396649c5k94117f0ce8017b5e@mail.gmail.com>
	 <1229163388.4153.867.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 11:16 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> You can continue to gloss over the real issues at hand here, but your
> generic handwaving certainly will not get you past RFC-3720 domain
> validation.

Every initiator ever tried against iSCSI-SCST works fine with it, and
that's what counts. So there is no "real issue".

Bart.
