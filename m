Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYGXTXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYGXTXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYGXTXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:23:36 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:63687 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYGXTXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:23:35 -0400
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: PPC: howto enable output from service processor at COM1?
Date: Thu, 24 Jul 2008 21:09:02 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242109.04450.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I am getting crazy unable to find solution how instruct service processor on 
IBM H70 output to COM1 port. From AIX it is easy in specifiing output 
to /dev/console and than assign /dev/console to tty0 (sa0).
How can I do this with linux?

Thanks for reply

Michal
