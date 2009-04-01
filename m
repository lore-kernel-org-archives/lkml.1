Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZDAUhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZDAUhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZDAUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:37:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40685 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZDAUhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:37:32 -0400
Date: Wed, 1 Apr 2009 21:37:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: qcserial comes up in unhelpful custom mode?
Message-ID: <20090401203726.GA17485@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The qcserial driver appears to bind with the device providing a "QDL" 
interface, whatever that is. The internet suggests that the device needs 
firmware loading before it'll do anything useful. Is there any code out 
there to do this on Linux, or is the driver currently fairly useless?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
